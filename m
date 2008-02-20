Return-Path: <linux-kernel-owner+w=401wt.eu-S1755413AbYBTFAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbYBTFAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 00:00:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750783AbYBTFAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 00:00:44 -0500
Received: from smtp-out.google.com ([216.239.45.13]:33205 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbYBTFAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 00:00:43 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:user-agent:date:from:to:cc:subject;
	b=kp/Llzj0NEAMHXZTyYqozZPB3cPTZm6SxPlpGdowoVbNmYdaFytKEbfywwA3yDg7G
	CARn9KrnRVxfeQfxLNpqQ==
Message-Id: <20080220045408.289180000@menage.corp.google.com>
User-Agent: quilt/0.45-1
Date: Tue, 19 Feb 2008 20:54:08 -0800
From: Paul Menage <menage@google.com>
To: akpm@linux-foundation.org, pj@sgi.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Cpusets API: Update Cpusets control files
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This pair of patches simplifies the cpusets read/write path for the
control files that consist of simple integers.

--
