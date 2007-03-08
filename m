Return-Path: <linux-kernel-owner+w=401wt.eu-S1752573AbXCHRBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbXCHRBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 12:01:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbXCHRBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 12:01:14 -0500
Received: from ip33.server2.digitalinet.com ([66.235.184.33]:54489 "HELO
	server2.digitalinet.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with SMTP id S1752570AbXCHRBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 12:01:14 -0500
Message-ID: <22858.83.60.135.204.1173373220.squirrel@webmail2.digitalinet.com>
In-Reply-To: <887.65866.qm@web36605.mail.mud.yahoo.com>
References: <887.65866.qm@web36605.mail.mud.yahoo.com>
Date: Thu, 8 Mar 2007 18:00:20 +0100 (CET)
Subject: Re: Request change in behaviour of capability inheritance.
From: rgarcia@kotasoft.com
To: casey@schaufler-ca.com
Cc: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I was reading the capabilities(7) man page. I agree with you about the
language. What I am requesting is that for any file without extra
attributes, the inheritable and effective set should be full.

Ramon

