Return-Path: <linux-kernel-owner+w=401wt.eu-S1763389AbXHWM0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763389AbXHWM0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 08:26:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760861AbXHWMZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 08:25:51 -0400
Received: from re01.intra2net.com ([82.165.28.202]:2412 "EHLO
	re01.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758085AbXHWMZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 08:25:50 -0400
From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Organization: Intra2net AG
To: linux-kernel@vger.kernel.org
Subject: Re: Kernel oops during netfilter memory allocation
Date: Thu, 23 Aug 2007 14:25:43 +0200
User-Agent: KMail/1.9.6
References: <200708201808.08880.thomas.jarosch@intra2net.com> <200708211133.56261.thomas.jarosch@intra2net.com> <200708221709.04992.thomas.jarosch@intra2net.com>
In-Reply-To: <200708221709.04992.thomas.jarosch@intra2net.com>
Cc: netfilter-devel@lists.netfilter.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708231425.43910.thomas.jarosch@intra2net.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello together,

I've found an easier way to demonstrate the bug
and filed a report at bugzilla.kernel.org:

http://bugzilla.kernel.org/show_bug.cgi?id=8928

Hope there will be a quick resolution for this issue
as the boxes crashing serve 800 users and more.

Best regards,
Thomas
