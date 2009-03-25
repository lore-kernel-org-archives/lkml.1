Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbZCYCYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbZCYCYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 22:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751007AbZCYCYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 22:24:34 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:43384 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbZCYCYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 22:24:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=yEC5YoXeQkCECGj7Wtl5IbBV/7x8wLhDvt4vkkibkZrK47nUnTuqOmAVxvzL0XnhmC
         2Tvum8fvkSHXYCCrt0ItMz404WpmJB+IF27UmuJBLVUiz58zYezbTqGYOQpUclh/nGdn
         bHC+R47XBxikrsMnQB+X7Gmto+eTyk/3rd/ME=
Message-ID: <49C995DA.40407@gmail.com>
Date: Tue, 24 Mar 2009 22:24:26 -0400
From: Maxim Siniavine <m.siniavine@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: How to assign a specific page to a user process?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Given a page frame number how can I make this page belong to a user
process? I can make it visible to the process by changing its page table
of course, but that does take into account any bookkeeping by the memory
manager. Can someone at the very list point to the portions of the code
that might be helpful with this?
