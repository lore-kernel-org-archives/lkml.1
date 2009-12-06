Return-Path: <linux-kernel-owner+w=401wt.eu-S934023AbZLFRrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934023AbZLFRrs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 12:47:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933941AbZLFRrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 12:47:48 -0500
Received: from lixom.net ([66.141.50.11]:35378 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756929AbZLFRrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 12:47:47 -0500
Date: Sun, 6 Dec 2009 11:50:27 -0600
From: Olof Johansson <olof@lixom.net>
To: Carsten Emde <Carsten.Emde@osadl.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/urgent] tracing: Fix trace_marker output
Message-ID: <20091206175027.GA9095@lixom.net>
References: <4B01AE5D.1010801@osadl.org> <tip-c13d2f7c3231e873f30db92b96c8caa48f100f33@git.kernel.org> <20091206051352.GA4628@lixom.net> <4B1BAB74.104@osadl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1BAB74.104@osadl.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 06, 2009 at 02:02:44PM +0100, Carsten Emde wrote:
> Olof,
> 
[...]
> Having looked at other possible solutions, I find that the best thing to do
> is to revert this part of the patch. Sorry that I didn't check it on ARM
> platforms.

Thanks, no worries. I figured there was a better way to fix it but
including a bad patch tends to be better than not including one :)


-Olof

