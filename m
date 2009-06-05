Return-Path: <linux-kernel-owner+w=401wt.eu-S1755019AbZFEQaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbZFEQaz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 12:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbZFEQar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 12:30:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:21695 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbZFEQar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 12:30:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=MuMat9ZE++9e92hcY3FUZg/rUNbjo6heSIQEzOLxzHj0SXHz6MoacNzH5sTAb7WHTK
         jf+R5aYA0K84YZqwyqNhxxZQnEbG7dBVObAL/OaVD5XE9NtH+jjoWSJNjq0gB2Ca1E66
         6O3q3d13/y+iMbkuDBJw2ANBGm0kTAnBQdWt0=
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 0/7] ASIC3 updates (v2)
Date: Fri,  5 Jun 2009 18:31:00 +0200
Message-Id: <1244219467-32136-1-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

second try. I've merged the new functions in patch 1 into asic3_set_register
and updated the following patches accordingly.

regards
Philipp
