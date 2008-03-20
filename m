Return-Path: <linux-kernel-owner+w=401wt.eu-S1757737AbYCTRBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757737AbYCTRBJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 13:01:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757123AbYCTRA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 13:00:56 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:5655 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008AbYCTRA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 13:00:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Rd7lngTFpDd70JO18QP7Zs028z6k3TciSuGFAQc3R585W1vFA1sCUOKEXN7jd5RrdVEpzaXKjz4sicvrOdxrcqw83gWA1iM1qQu7r4tRrGw664FfD8UnbkBuFpMP2A2NHHnLg6ukf+j5hKWpFyVMRzSti6A6PwblQFZXqEls+fM=
Message-ID: <5b1d25eb0803201000s7b60143fl61afd832140c2ac4@mail.gmail.com>
Date: Thu, 20 Mar 2008 10:00:54 -0700
From: "Sreen Tallam" <tallam.sreen@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Device tree file customization for 2.6.18
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I have been using 2.6.10 until now and moving over 2.6.18.
And I trying to build a 2.6.18 kernel for a PowerPC 405GP.

I discovered that there is a .dts file needed by the kernel.
I have no idea how to customize this file. Any tips, suggestions or
Documentation that I can look at?

I am using u-boot as my board's FW.
Also, I have a Walnut like board for which I am building the kernel.

Appreciate your help in this issue.

Thanks,
Sreen
