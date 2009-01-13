Return-Path: <linux-kernel-owner+w=401wt.eu-S1760157AbZAMJHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760157AbZAMJHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 04:07:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758214AbZAMJFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 04:05:13 -0500
Received: from rv-out-0506.google.com ([209.85.198.229]:11508 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756572AbZAMJFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 04:05:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JSS6f7bAfGj7UFwTFUhsbmiLELEXkkr19NNU41YPL6+Dw45k0t25BjVxomHN/cqaZM
         bJLVPeXMt5mx3MNA6pGJcVRGQfOYGPOO5vTuHdY8VzWHJm733tQXi449LMnR/JMXJr3P
         GoxcREVf0cXrleuyE4g0jLNMxDGpV0NTqyRy0=
Message-ID: <a80c86b70901130105v74feff29y445a82e0694d3d89@mail.gmail.com>
Date: Tue, 13 Jan 2009 14:35:05 +0530
From: "Prateek Donni" <prateek.donni@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: A kind of file monitor
In-Reply-To: <a80c86b70901100833k7a2f3667hcada40f7737530@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a80c86b70901100833k7a2f3667hcada40f7737530@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey guys , i needed some help on building a file monitor which
monitors alll file accesses and manages historical data of the same,
kindly tell if 'inotify' can be good enough for the same
