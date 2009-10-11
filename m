Return-Path: <linux-kernel-owner+w=401wt.eu-S1753603AbZJKXMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbZJKXMm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 19:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbZJKXMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 19:12:39 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:57428 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbZJKXMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 19:12:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Gi7BjJbebWJrowCZWcoA/1oymWlPDwyCiPVvS9qvVhtDNGC9pJrlWsLOA3e8TOGBQO
         3ciaCuIDoY8dwdSq9KsGNvfL+gJx1MVW22eLfiLoOMr+YdME1p8zSYi4q2ITlEWKcoLP
         gkppS3K+aAlZti6hayNc4AK4zoE4GHhlByq7c=
Message-ID: <4AD2662A.5050709@gmail.com>
Date: Sun, 11 Oct 2009 16:11:38 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009022519)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>
Subject: Re: [Bug #14267] Disassociating atheros wlan
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera> <L6tb-VyKHZK.A.AQC.izl0KB@chimera>
In-Reply-To: <L6tb-VyKHZK.A.AQC.izl0KB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.30 and 2.6.31.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14267
> Subject		: Disassociating atheros wlan
> Submitter	: Kristoffer Ericson<kristoffer.ericson@gmail.com>
> Date		: 2009-09-24 10:16 (18 days old)
> References	: http://marc.info/?l=linux-kernel&m=125378723723384&w=4
>
>
>
>    
I attached my bisect log to the bug report, but did not individually test
some of the commits in the log to see if it finds the issue.
(I can try later on and see).

so for now I say yes keep it open.

Justin P. Mattock

