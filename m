Return-Path: <linux-kernel-owner+w=401wt.eu-S1758797AbZIFV1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797AbZIFV1h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 17:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758702AbZIFV1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 17:27:36 -0400
Received: from smtp-out.google.com ([216.239.45.13]:49733 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758215AbZIFV1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 17:27:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=abgM2ukEJzf08c71u8iveBeimK0By6/Qrrw42SI+13V1LoJ0OznwTau4IgKzMu3gr
	4Bz5GFTIgaLBl7h24AeVg==
Date: Sun, 6 Sep 2009 14:27:29 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Kurt Roeckx <kurt@roeckx.be>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13780] NULL pointer dereference loading powernowk8
In-Reply-To: <hKF51Pczj6N.A.Y9H.r3BpKB@chimera>
Message-ID: <alpine.DEB.1.00.0909061426500.16301@chino.kir.corp.google.com>
References: <aIL9jMAYJnG.A.WjH.M3BpKB@chimera> <hKF51Pczj6N.A.Y9H.r3BpKB@chimera>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Sep 2009, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.29 and 2.6.30.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13780
> Subject		: NULL pointer dereference loading powernowk8
> Submitter	: Kurt Roeckx <kurt@roeckx.be>
> Date		: 2009-07-15 18:00 (54 days old)
> 

This bug has been abandoned as far as I know since there has been no 
response from the reporter in three weeks to post the latest failure 
(which was then 2.6.31-rc5).
