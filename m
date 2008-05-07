Return-Path: <linux-kernel-owner+w=401wt.eu-S1758090AbYEGMjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090AbYEGMjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 08:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbYEGMjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 08:39:12 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:47269 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbYEGMjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 08:39:08 -0400
Subject: [PATCH 0/3] [2.6.26] ehea: Add DLPAR memory remove support
Content-Disposition: inline
From: Hannes Hering <hannes.hering@linux.vnet.ibm.com>
Date: Wed, 7 May 2008 14:39:06 +0200
MIME-Version: 1.0
Organization: IBM
To: jeff@garzik.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org, ossrosch@linux.vnet.ibm.com,
       ossthema@de.ibm.com, raisch@de.ibm.com, themann@de.ibm.com,
       tklein@de.ibm.com
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200805071439.06460.hannes.hering@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patchset adds memory remove hotplug support for the ehea driver. 

These patches apply against kernel 2.6.26-rc1.

Regards

Hannes
