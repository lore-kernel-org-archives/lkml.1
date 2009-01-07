Return-Path: <linux-kernel-owner+w=401wt.eu-S1751940AbZAGQOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbZAGQOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 11:14:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbZAGQNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 11:13:52 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:58542 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbZAGQNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 11:13:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=OfF20o1nyF9qdQmI5Z7wOb/XM3OoZ8Xc0EHOt/oq9Kitp8qLm4fRSy566TVvRQekHv
         ROHBJINl97XbY2uYxPR6wEdL8bVWcLJyU39cjkFS5ajn7JCGMoRj+JcxyJcJyF0q+oNg
         /pH7oA11zhhGfqbti6OGA6dbBDb+UNqx+k1zo=
From: Bryan Wu <cooloney@kernel.org>
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Blackfin EMAC driver updates
Date: Thu,  8 Jan 2009 00:14:37 +0800
Message-Id: <1231344879-26069-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Jeff,

Please take a look at these 2 patches for Blackfin EMAC driver

Thanks
-Bryan
