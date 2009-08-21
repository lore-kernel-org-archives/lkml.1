Return-Path: <linux-kernel-owner+w=401wt.eu-S1755812AbZHUS76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812AbZHUS76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 14:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755783AbZHUS75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 14:59:57 -0400
Received: from ns1.ata-over-ethernet.org ([12.51.113.4]:36994 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755776AbZHUS75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 14:59:57 -0400
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Fri, 21 Aug 2009 14:58:23 -0400
To: apw@canonical.com, ecashin@coraid.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] aoe: ensure we initialise the request_queue correctly
Message-ID: <b955c44a492c558481822d9b07fce3b8@coraid.com>
In-Reply-To: <1250872904-10993-1-git-send-email-apw@canonical.com>
References: <1250872904-10993-1-git-send-email-apw@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It would be very interesting to find out what the results of a git
bisect would show.  Is that something you could do?

Thanks for the report and the patch.  I'm looking at the changes now.

-- 
  Ed
