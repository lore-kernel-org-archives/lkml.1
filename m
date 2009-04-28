Return-Path: <linux-kernel-owner+w=401wt.eu-S1759679AbZD1KQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759679AbZD1KQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 06:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759059AbZD1KQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 06:16:14 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:58226 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759007AbZD1KQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 06:16:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        b=Aon5YjGFztU4G36lbU/6qJV+h7vpMx7HLNGialvFxb8dbEEe4iRN/yVlcNWkLokolh
         uLGISoIcq+a4rxIlKWzV734E28R0Ui+4YkTsq4/i078qetwvxd4m9NQttm+TW4dTu/+M
         MWk6sMVYEylNvyHNy5VOWkgklN3sEgkzAevew=
MIME-Version: 1.0
Date: Tue, 28 Apr 2009 18:16:11 +0800
X-Google-Sender-Auth: 2010cc7b588a366d
Message-ID: <2a27d3730904280316l7049bddbie914907b16ccfff6@mail.gmail.com>
Subject: [PATCH 0/5] rapidio: adding memory mapping IO support and misc fixes
From: Li Yang <leoli@freescale.com>
To: akpm@linux-foundation.org, Kumar Gala <galak@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, mporter@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org,
       linuxppc-dev Development <linuxppc-dev@ozlabs.org>,
       Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch series add MMIO support to Linux rapidio and fix a few nits.
 The patches cross rapidio, netdev, powerpc sub-systems.  It will be
good for them to go through one tree.  Probably Andrew?  As the
previous rapidio patches are mostly merged by you.

- Leo
