Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab0BYDVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 22:21:25 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:43051 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab0BYDVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 22:21:24 -0500
From: Oliver Neukum <oliver@neukum.org>
To: linux-kernel@vger.kernel.org
Subject: question on bisecting with an additional patch needed
Date: Thu, 25 Feb 2010 04:21:01 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc8-0.1-default; KDE/4.3.1; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002250421.01550.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am debugging an issue that shows up only with a modified driver
but is caused in another subsystem. Can git be told that the trees
resulting from each step in a bisection should have a patch applied?

	Regards
		Oliver
