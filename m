Return-Path: <linux-kernel-owner+w=401wt.eu-S1764264AbXGQWKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764264AbXGQWKR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 18:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757453AbXGQWKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 18:10:04 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:50976 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757357AbXGQWKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 18:10:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=rZ6I/k8zRqbZQbQ79YQG789oZM3aKHIRR/k7IVAf2oG8vj2hnPKriXKhLhqq8LhKLg5U8wR0lbEKkLKhpRHCmQ4lPHq+fgzpm0YgwaFd8z5/tSihnNO4rk6q6FbIqIe61rpiLmJnIyAK8EzCK8kB4AWRHtktrGv28pWQQFh2u3Q=
Message-ID: <a4e6962a0707171510u6ead741cmaeaa260899a79718@mail.gmail.com>
Date: Tue, 17 Jul 2007 17:10:00 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: torvalds@osdl.org,
       "V9FS Developers" <v9fs-developer@lists.sourceforge.net>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] 9p patch to fix compilation issue
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the 'for-linus' branch of:
 git://git.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git/ for-linus

This tree contains the following:

Dave Jones(1):
  fix debug compilation error

 v9fs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)
