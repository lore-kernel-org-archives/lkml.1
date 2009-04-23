Return-Path: <linux-kernel-owner+w=401wt.eu-S1757138AbZDWOMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138AbZDWOMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 10:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbZDWOMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 10:12:40 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:55019 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbZDWOMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 10:12:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=LOsx9ew4nWSWdcOQiMALFAz4eO1l1aIVBvKnL0yPrTy0L6h44WC2mjz16NkRNeh1cX
         AQv4XgcS34AzoCTnZjPJNHXhlcx5dlptUv3JS5Qvu/HF54UzbRTQXb++CnWY3FpHKY4U
         AeILXDcu3xhAnNyPHvtTj/QO6Pm2nX/xt5QYE=
MIME-Version: 1.0
Date: Thu, 23 Apr 2009 16:12:38 +0200
Message-ID: <38b2ab8a0904230712r44fe1a63k89e8529b7c6859bc@mail.gmail.com>
Subject: http://www.kernel.org/hg
From: Francis Moreau <francis.moro@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Could anybody tell me how the kernel git repo is converted
into a hg one ?

I tried to achieve the same with "hg convert" but I don't get
exactly the same result. The tags are somehow moved to
the "update tags" commits instead of the commit which is
tagged in the git repo.

thanks
-- 
Francis
