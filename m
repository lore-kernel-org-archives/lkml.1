Return-Path: <linux-kernel-owner+w=401wt.eu-S1759925AbYAJTIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759925AbYAJTIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:08:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754676AbYAJTHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:07:11 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:58990 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179AbYAJTHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:07:10 -0500
Subject: [RFC][PATCH 0/4] kill open files traverse on remount ro
To: linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, hch@infradead.org, serue@us.ibm.com,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Thu, 10 Jan 2008 11:06:57 -0800
Message-Id: <20080110190657.92A8B61F@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just RFC for now.  I'm tracking down a wee bit of
list corruption.  But, I wanted to send out so you could
compare to the last approach.

