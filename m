Return-Path: <linux-kernel-owner+w=401wt.eu-S1758361AbYDPRsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758361AbYDPRsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 13:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752321AbYDPRr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 13:47:58 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:64432 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbYDPRr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 13:47:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=user-agent:date:from:to:cc:subject:message-id;
        b=cWiu8eXjHUzyuh0oeUz5cxNTkRmiXlDPypCTz3GwrEoMQtcZfJy2qKyH6Mnl1Q8AqMecwYTG9Jnq00QlIQwDdTVDSXcMJmKjiMafLnXK83SIzhAKwTCFHHSHsWH3rRQTSTVnfMHRHQeu//qcdAPeAUWBhl0rkpg8s4Or1Pa7OCI=
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 21:44:21 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: bfields@fieldses.org, neilb@suse.de, ibm-acpi@hmh.eng.br,
       len.brown@intel.com, kkeil@suse.de
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 0/3] [PATCH] NULL pointer dereference and memory leak fixup
Message-ID: <48063bc8.2233440a.3670.1255@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a series of patches that fixes NULL pointer dereference in NFS,
ACPI Thinkpad and fix memory leak in CAPIFS.

Please review, any comments are quite *welcome*!

		- Cyrill -
-- 
