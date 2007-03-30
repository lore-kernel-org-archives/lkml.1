Return-Path: <linux-kernel-owner+w=401wt.eu-S1753818AbXC3DhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbXC3DhX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 23:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753815AbXC3DhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 23:37:23 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:53311 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818AbXC3DhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 23:37:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=OM/+LDW/meRireU0XObl8KXDSQMuYGndOeUwh8mWRmkmmbVAzCL4Kj76ZyPAvojPsBWmgNNPLwdCD1JhSWcYBzW2XJdb+9W5W3SjdJlVD1CIrFazpiLF92HzNqWc+sA5Z/1gdFXHWoJ852VWZEkab3ThTrofRY/94hwgetRbuL8=
Message-ID: <5767b9100703292037n57a09807qb07c20fe589273e@mail.gmail.com>
Date: Fri, 30 Mar 2007 11:37:20 +0800
From: "Conke Hu" <conke.hu@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Use C++ in kernel module?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Is it possible to use C++ in linux kernel module? how?
I've tested but failed, there is an unknown symbol in the .o file from
c++ source code.

Conke
