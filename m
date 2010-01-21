Return-Path: <linux-kernel-owner+w=401wt.eu-S1753194Ab0AUMDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab0AUMDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 07:03:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752706Ab0AUMDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 07:03:52 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39330 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752689Ab0AUMDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 07:03:52 -0500
Date: Thu, 21 Jan 2010 12:04:05 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <htejun@gmail.com>
Cc: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       jgarzik@pobox.com, Reinhard.Tartler@informatik.uni-erlangen.de
Subject: Re: [PATCH #upstream-fixes] libata-sff: remove CONFIG_NO_ATA_LEGACY
Message-ID: <20100121120405.1085b6d3@lxorguk.ukuu.org.uk>
In-Reply-To: <4B579C4A.3040907@gmail.com>
References: <20100120142943.GE3580@faui49.informatik.uni-erlangen.de>
	<4B579C4A.3040907@gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jan 2010 09:14:02 +0900
Tejun Heo <htejun@gmail.com> wrote:

> CONFIG_NO_ATA_LEGACY isn't used by anyone.  Drop it.
> 
> Reported-by: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
> Signed-off-by: Tejun Heo <tj@kernel.org>

Not unless this is cleared with the FRV maintainers who were using
it and I believe may still need it.

Mr Howells ?


