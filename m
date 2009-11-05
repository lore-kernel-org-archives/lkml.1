Return-Path: <linux-kernel-owner+w=401wt.eu-S1758451AbZKES7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758451AbZKES7L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 13:59:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757938AbZKES7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 13:59:10 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:38409 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757932AbZKES7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 13:59:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=KtfLqBrUS8t303R7F8mvmCihLzqaecaS4WPzt91CHEEZl8LPERv3t6sRIJP7cMNh6c
         5IuFbSo2jc54ifNKWUU5xh1ZMJn8eM4zCu0dGejw2xA9maJ6Sh0746KVxHVtEMGVlqE5
         afhtRrheOMAud5yNzwNkKLaMFJCDlYs/Ag1q4=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 27/41] rt2x00: fix rt2x00usb_regbusy_read() arguments
Date: Thu, 5 Nov 2009 19:59:10 +0100
User-Agent: KMail/1.9.10
Cc: linux-wireless@vger.kernel.org, Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173518.28463.61728.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173518.28463.61728.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911051959.11213.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 November 2009, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2x00: fix rt2x00usb_regbusy_read() arguments
> 
> Add const to 'field' argument of rt2x00usb_regbusy_read()
> (all arguments match rt2x00pci_regbusy_read() ones now).
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

