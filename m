Return-Path: <linux-kernel-owner+w=401wt.eu-S1754137AbZF1BXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbZF1BXv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 21:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbZF1BXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 21:23:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59115 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262AbZF1BXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 21:23:43 -0400
Subject: Re: [linux-cifs-client] Re: [PATCH] cifs: fix fh_mutex locking in
 cifs_reopen_file
From: Jeff Layton <jlayton@redhat.com>
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org
In-Reply-To: <524f69650906271710n663e4f21x106b5deaa81e20c0@mail.gmail.com>
References: <1246100695-10344-1-git-send-email-jlayton@redhat.com>
	 <524f69650906271710n663e4f21x106b5deaa81e20c0@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 27 Jun 2009 21:23:44 -0400
Message-Id: <1246152224.7960.1.camel@tupile.poochiereds.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-06-27 at 19:10 -0500, Steve French wrote:
> Good catch .
> 
> I have reviewed and merged into cifs-2.6.git. Merge requested for upstream.
> 

Great. Did it fix the problems you were seeing when testing with dbench?

-- 
Jeff Layton <jlayton@redhat.com>

