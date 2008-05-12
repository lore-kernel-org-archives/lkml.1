Return-Path: <linux-kernel-owner+w=401wt.eu-S1760932AbYELKcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760932AbYELKcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 06:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757841AbYELKcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 06:32:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:31450 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756953AbYELKcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 06:32:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer:sender;
        b=d3Jvw2BKQzxoZNxBsoAk+InE5GUijGL9Oa1KVyPLeW2i/yaMCN392AE002tFtnfub4xkr4G1flM6hoSp1RNb9XY39ABw3yXXSTGNFFqVgPVd9GpeZf5uHCEFQ2ug4nDpZEp9NsVAnB7Rdu9G7odpCMMmmZtbWYPazLRSF66MJNQ=
From: Bryan Wu <cooloney@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, dwmw2@infradead.org
Subject: [PATCH 0/4] Memory management patches from Blackfin team
Date: Mon, 12 May 2008 18:32:01 +0800
Message-Id: <1210588325-11027-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

Here are some patches related memory managment, especially related
NOMMU code. Could you please review it?

Thanks
-Bryan


