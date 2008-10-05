Return-Path: <linux-kernel-owner+w=401wt.eu-S1758350AbYJEQpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758350AbYJEQpf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759550AbYJEQlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:41:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:32799 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085AbYJEQlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:41:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=ubONzYlqrkDa8bMSmcTEJIpUQGFvA9ZYI9ohbZX8a/8TPXU394CfmiIANnpcIy6+Cm
         t6wwvZyopPUgmyCpDV7hxExAZ0wFLS90Y1BTxUW7IFLiKB8zqEiWQhAkqLq82MMQzMOj
         RDiX2tt9Rx3B2usb1zPqw6CBNJOWg6Qr04l0c=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH 2/3] ide-cd: small drive type print fix
Date: Sun, 5 Oct 2008 17:54:15 +0200
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1222669799-6565-1-git-send-email-petkovbb@gmail.com> <200810031918.15455.bzolnier@gmail.com> <20081004082827.GA4160@gollum.tnic>
In-Reply-To: <20081004082827.GA4160@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810051754.24062.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 04 October 2008, Borislav Petkov wrote:
> On Fri, Oct 03, 2008 at 07:18:15PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > On Monday 29 September 2008, Borislav Petkov wrote:
> > > Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> > 
> > applied (though I fail to see "an added value" of this change)
> 
> It simply makes the format consistent with the lines below: CD-R/RW - which is
> the more common way of enumerating supported media you find in different specs
> than DVD-R-RAM, don't you think?

Indeed, thanks for explaining it.
