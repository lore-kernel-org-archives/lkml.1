Return-Path: <linux-kernel-owner+w=401wt.eu-S1755160AbYJMRsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160AbYJMRsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 13:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbYJMRso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 13:48:44 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:15337 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbYJMRsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 13:48:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=iyzserviOqmFTGr1PeSRxMKuUj+0diujr4C1bXLfcer3/dXU0kGv68tdUVxcwfLOiE
         nzaelULSfaMxoEic3g5q7bLLvYVfceyhJ2wLKqvrsl5DG1HqVDNbbEF8L0yhsVDIGT0I
         RNT6cv7TCezYfG7OTPjz3fVu+/lGecx4SBhXc=
Message-ID: <1ef1ea510810131048s3daecedfsa845c3ff5d4ca99a@mail.gmail.com>
Date: Mon, 13 Oct 2008 10:48:42 -0700
From: "Thomas Tanaka" <thomas.tanaka@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [Contol Groups] Filesystem namespace isolation using cgroups
Cc: thomas.tanaka@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is it possible to achieve file system namespace isolation using
cgroups ? My main goal is to build a container with the capability of
limiting the view of a given process, similar to what chroot does.

Thank you very much in advance

Regards,

Thomas
