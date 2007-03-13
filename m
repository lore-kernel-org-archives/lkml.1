Return-Path: <linux-kernel-owner+w=401wt.eu-S1753203AbXCMKBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbXCMKBE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 06:01:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbXCMKBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 06:01:04 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:46438 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbXCMKBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 06:01:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=eLyA3cvZJ7tX03ZVEPiicoMF2yfrE7/H/d4kNndGryFkla+Rnv2iZrBRDGWPFnYbi6MrvL2+DTNCH4JCPgmOJtlKjSyWyAcJFVKwx7d9r0LqJHrDZCR71HBbQPm6ERUHm3LT3gWZsqB2rgwstThJTZjzU8TX51IUeCsHGXuZ7E4=
Message-ID: <3634de740703130300j12928fbeob860c067e46badbf@mail.gmail.com>
Date: Tue, 13 Mar 2007 15:30:59 +0530
From: Maximus <john.maximus@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Porting V4L2 drivers to 2.6.20
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,
         am porting V4L2 drivers from 2.6.13 to 2.6.20.

     The driver is using a  structure 'video_device' which exists in
include/linux/videodev.h.

     However, The linux kernel in 2.6.20 doesnot have that structure?.

      Has the architecture changed between 2.6.13 to 2.6.20 for V4L2?.



      Regards,
       Jo
