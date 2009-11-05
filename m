Return-Path: <linux-kernel-owner+w=401wt.eu-S1758118AbZKES6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118AbZKES6s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 13:58:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757672AbZKES6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 13:58:48 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:37212 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757039AbZKES6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 13:58:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=H530p2/GUhdcvTPNYmqV1wcR/jhqus4n/HOklZKU9funREXPHSfrShGsGNW0kT2lHi
         L3BooaRz3ke2exBGYVkdsNKrtX+orctTH8L8luLnUov9is4dSXIJOzlfiCbTH9jjoIwf
         4q4azmKi533LQNAktuB/rfoG9ToYyoteFstwk=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 26/41] rt2x00: fix rt2x00usb_register_multiwrite() arguments
Date: Thu, 5 Nov 2009 19:58:49 +0100
User-Agent: KMail/1.9.10
Cc: linux-wireless@vger.kernel.org, Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173510.28463.24779.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173510.28463.24779.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911051958.49439.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 November 2009, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2x00: fix rt2x00usb_register_multiwrite() arguments
> 
> Add const to 'value' argument of rt2x00usb_register_multiwrite()
> (all arguments match rt2x00pci_register_multiwrite() ones now).
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

