Return-Path: <linux-kernel-owner+w=401wt.eu-S1754979AbXFMVOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979AbXFMVOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 17:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbXFMVOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 17:14:11 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:14303 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbXFMVOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 17:14:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=R6hPNbk8e43kc/Oddxi8ESMy8ChaH8qfEJXA6QCiMZ0/6DmiBrPTiafIqh04XQqAfJBN/ZMLvcavtmA4SPF1ZNCliOT5Pzcy7iVEecmivGi1cLnA9fj5I7FwNA/JxdZHgMqo274S/M4h3EyzBItoy3vf4d1xmz1ODYZx3MhY0FY=
Message-ID: <fa4052ef0706131414o27b2281bp81d3f5b3d3104f87@mail.gmail.com>
Date: Wed, 13 Jun 2007 17:14:09 -0400
From: Shane <gnome42@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH RT] fix migrating softirq [cause of network hang]
Cc: rostedt@goodmis.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

I have applied this patch to 2.6.21.4-rt13 and I think it might have
solved my bizarre nfs hangage issues that cropped up lately. Thanks
for tracking that down it was driving me nutz!

It has only been a few hours, but if you don't hear back from me in
the next day or so then it's good to go IMVHO. :)

Shane
