Return-Path: <linux-kernel-owner+w=401wt.eu-S1753482AbYH1RKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbYH1RKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 13:10:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755769AbYH1RJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 13:09:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33516 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755143AbYH1RJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 13:09:50 -0400
Date: Thu, 28 Aug 2008 17:52:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
Cc: sam@ravnborg.org, linux-kernel@vger.kernel.org
Subject: Re: PATCH: Kbuild: mkspec has to include /lib/firmware contents
Message-ID: <20080828175222.5a62045e@lxorguk.ukuu.org.uk>
In-Reply-To: <20080828140726.2feee90b@doriath.conectiva>
References: <20080828140726.2feee90b@doriath.conectiva>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2008 14:07:26 -0300
"Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br> wrote:

> 
> We have to include the contents of /lib/firmware directory when building
> the RPM package, otherwise the build will fail because of unpackaged
> files.
> 
> Signed-off-by: Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br>
Acked-by: Alan Cox <alan@redhat.com>
