Return-Path: <linux-kernel-owner+w=401wt.eu-S965300AbXHGWQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965300AbXHGWQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758495AbXHGWQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 18:16:29 -0400
Received: from rwcrmhc15.comcast.net ([204.127.192.85]:60028 "EHLO
	rwcrmhc15.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757061AbXHGWQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 18:16:27 -0400
Message-ID: <46B9014E.5020209@wolfmountaingroup.com>
Date: Tue, 07 Aug 2007 17:33:34 -0600
From: "Jeffrey V. Merkey" <jmerkey@wolfmountaingroup.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.8) Gecko/20050513 Fedora/1.7.8-2
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: paul.pinault@disk91.com
CC: linux-kernel@vger.kernel.org
Subject: Re: Data corruption
References: <200708072007.27343.paul.pinault@disk91.com>
In-Reply-To: <200708072007.27343.paul.pinault@disk91.com>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Check for the errata on the disk device you are using from the 
manufacturer and see if there are recovery issues with ECC
detection.   I saw a similiar issue with Maxtor drives at one point and 
it turned out to be a bad batch of microcode on the drive
itself with random data errors when ECC was enabled.

Jeff
