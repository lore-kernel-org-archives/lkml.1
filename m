Return-Path: <linux-kernel-owner+w=401wt.eu-S1756750AbYDHRqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbYDHRqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 13:46:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756424AbYDHRp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 13:45:56 -0400
Received: from rv-out-0708.google.com ([209.85.198.244]:28421 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756423AbYDHRpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 13:45:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=TYPO2wSLtHa2Q6df1hUcAzQ7Fm8F8YisnLSmSp9erybYhTx+7lv5bkVeQ8jTFEfTK67kdEui4paXc8Ii9zwStAhFmHsn7PEE4KGkgb0UbHHNApnybQcimhH4fbdrgK0wlfkF6G/ZkT6Dqx075lNRBIMYxtPHTvxXaUmryzRkKYU=
Message-ID: <a72f6a3c0804081045r6eb4c6awdae2f3be0ccc416e@mail.gmail.com>
Date: Tue, 8 Apr 2008 18:45:55 +0100
From: "Jack Harvard" <jack.harvard@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: lmbench memory bandwidth benchmark
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi, can someone help explain how bw_mem function works in lmbench? the
source code doesn't seem very user friendly, the papers are too vague
to help understand the code. an example for "bw_mem 512 frd" would be
very helpful.
