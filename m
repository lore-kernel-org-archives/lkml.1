Return-Path: <linux-kernel-owner+w=401wt.eu-S1762051AbXELBcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762051AbXELBcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 21:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755048AbXELBcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 21:32:16 -0400
Received: from web60012.mail.yahoo.com ([209.73.178.75]:46702 "HELO
	web60012.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754789AbXELBcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 21:32:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=fcZGdkrDxQY5kRvvXW+3OQau0eTPrejQqyjSZGditcr6yuCrbaY/3IT9rNMzxI/jsuF7qlD55RIM7oRr3j5mQITXZvGw76npdrLO51M8x9b5Gty+qcTeFr5Q06dJybIpn8tvMmiVA6ElQ9P4p9ii6BhC+o+6oOXIuLg2PWqglM8=;
X-YMail-OSG: 7Pog4v8VM1mrdxB8uNV3BFk4ZDM5WVezMNOMoOR0FIC.6RzT21H5NlATnkbk8UKlLwp1eW4iHFyrhfu.ALc_5DszlLsAbnDXnzIBeJrr16.3oKjelyxafczqY5ALjQE-
Date: Fri, 11 May 2007 18:32:14 -0700 (PDT)
From: Charles Gagalac <charle97@yahoo.com>
Reply-To: charle97@yahoo.com
Subject: Re: [Bugme-new] [Bug 8462] New: applications under wine freezes
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0705111254010.21112@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <923133.74668.qm@web60012.mail.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Davide Libenzi wrote:

> Charles, would you mind trying the patch below
> against -git13 on your 
> machine. I tested it with wine and firefox on a 32
> bit P4 with HT and it's 
> working fine.

i applied the patch against git13.  starcraft,
pokerstars, and firefox under wine have not frozen. 
looks good.



 
____________________________________________________________________________________
Never miss an email again!
Yahoo! Toolbar alerts you the instant new Mail arrives.
http://tools.search.yahoo.com/toolbar/features/mail/
