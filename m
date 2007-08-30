Return-Path: <linux-kernel-owner+w=401wt.eu-S932219AbXH3OIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219AbXH3OIH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 10:08:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbXH3OH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 10:07:56 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:45856 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbXH3OHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 10:07:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ms4r8eDO1+BV6vHzjbfyQ3iiwmmbTq0y9GJ+wrefwtg14Gk1GR/wDhpBAYhDgB1e0XbMhHBdqmr/h4nLnzwt8n4qIzJAyQzTMGjSGg/Prab/LDTyXIyivaWXknE9VPIQ7OEhLmC48EEzfzw4w5hAD1mbaB4BKA8pPKnS9Hm2/Ag=
Message-ID: <ab40e9c0708300707r2e6d2d71y42940084db5038ac@mail.gmail.com>
Date: Thu, 30 Aug 2007 16:07:53 +0200
From: "Xu Yang" <risingsunxy@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: parse_tag_ramdisk
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,


I found that in the function parse_tag_ramdisk , the setup_ramdisk is
called. is it true that in the setup_ramdisk the location ot the
initrd is specified?

it seems that in my case the parse_tag_ramdisk is never accessed. what
might cause this?

in the parse_tag_ramdisk  the tag should be specified, where to
specify the "tag" and how?

thanks your answer is appreciated.

regards,

yang
