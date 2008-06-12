Return-Path: <linux-kernel-owner+w=401wt.eu-S1755544AbYFLPa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbYFLPa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 11:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbYFLPaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 11:30:46 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:54020 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbYFLPaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 11:30:46 -0400
Message-Id: <20080612152645.445504681@kerlabs.com>
User-Agent: quilt/0.46-1
Date: Thu, 12 Jun 2008 17:26:45 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Joel.Becker@oracle.com
Cc: Louis.Rilling@kerlabs.com, ocfs2-devel@oss.oracle.com,
       linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 0/3] configfs: Miscellaneous fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following patches fix few bugs/APIs in configfs. The third one depends on
the patch introducing configfs_dirent_lock previously submitted in 
http://lkml.org/lkml/2008/6/12/232

Louis

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

