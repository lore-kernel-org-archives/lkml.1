Return-Path: <linux-kernel-owner+w=401wt.eu-S1758027AbYJWVuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027AbYJWVuh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 17:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871AbYJWVuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 17:50:10 -0400
Received: from gv-out-0910.google.com ([216.239.58.186]:6727 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692AbYJWVuI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 17:50:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=KVhPVxZ01+hDoYVI8183d6gcuidWdEmAna6aGNRlR7JcQRNs9jT07xGz+VQSgIIqXz
         I9eQjLse1eX6DRM4rWQ4CehFt6u3BlpkgkvXm6e58ua44ZCZTh6Gab8JxTPC7rkUWF6S
         InPwONQgLaDOJgk0VSsrMVGqPskpm9SVOfg3I=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH] cdrom: add TEAC CD-224E to the NO_AUTOCLOSE list
Date: Thu, 23 Oct 2008 22:50:03 +0200
User-Agent: KMail/1.9.10
Cc: "=?iso-8859-1?q?N=E9meth?= =?iso-8859-1?q?_M=E1rton?=" 
	<nm127@freemail.hu>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <4900655E.7050906@freemail.hu> <9ea470500810230537u559fff3chda7c6f47927bf1b0@mail.gmail.com>
In-Reply-To: <9ea470500810230537u559fff3chda7c6f47927bf1b0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200810232250.03290.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 October 2008, Boris Petkov wrote:
> On Thu, Oct 23, 2008 at 1:51 PM, Németh Márton <nm127@freemail.hu> wrote:
> > From: Márton Németh <nm127@freemail.hu>
> >
> > The "TEAC CD-ROM CD-224E" cannot close its tray, so add it to the NO_AUTOCLOSE list. This
> > will correct the "Can close tray" field of /proc/sys/dev/cdrom/info.
> >
> > Signed-off-by: Márton Németh <nm127@freemail.hu>
> 
> Acked-by: Borislav Petkov <petkovbb@gmail.com>

applied
