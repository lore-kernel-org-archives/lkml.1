Return-Path: <linux-kernel-owner+w=401wt.eu-S1755299AbZFLLtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbZFLLtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 07:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755414AbZFLLtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 07:49:07 -0400
Received: from mail-px0-f187.google.com ([209.85.216.187]:42249 "EHLO
	mail-px0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbZFLLtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 07:49:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=WCvQm5lwP7uZ2foqiuD3Rp+d27CN1vzYkbRtKsnH+6wrF7sBuTrN1v/jD53gkt47ok
         xGKEO7M75ohvTPdXXH4rPrHGIqqlGnIQDPYnxZOwKXMd2/fRgshjSdXiM27QshD0pRea
         B2+Z68uyDGmglt51s8Llh9Jo6yZMG9/bhK4X0=
MIME-Version: 1.0
In-Reply-To: <a160a7d60906120427w3510f52fva99792d6c00c3bc7@mail.gmail.com>
References: <a160a7d60906120427w3510f52fva99792d6c00c3bc7@mail.gmail.com>
From: Sucan Zhang <bitzsk@gmail.com>
Date: Fri, 12 Jun 2009 19:42:15 +0800
Message-ID: <a160a7d60906120442t7d5d0eb6v2fb3da7f635866ce@mail.gmail.com>
Subject: How to make the block number of a file not change?
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

when i modify a file ,the block number of the file will be changed
instantly, how to modify the linux kernel or some part of ext3
filesystem to let

the block number not change?

Thanks!

--
Regards,
Sucan



-- 
Regards,
Sucan
