Return-Path: <linux-kernel-owner+w=401wt.eu-S1758083AbZEKRys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083AbZEKRys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 13:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754422AbZEKRyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 13:54:35 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:40262 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbZEKRye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 13:54:34 -0400
Message-ID: <4A08666A.6020700@oracle.com>
Date: Mon, 11 May 2009 10:54:50 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
       sandeen@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC] fiemap tester
References: <20090508191649.GG9068@unused.rdu.redhat.com> <20090508161318.c73d766c.akpm@linux-foundation.org> <20090511094639.GA7488@infradead.org> <20090511171046.GA21518@mit.edu>
In-Reply-To: <20090511171046.GA21518@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt004.oracle.com [141.146.116.13]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A01020A.4A0865F5.00F4:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Mon, May 11, 2009 at 05:46:39AM -0400, Christoph Hellwig wrote:
>> Last time I brought the idea of a small in-tree test harness up at KS
>> people weren't too fond of it, but if we get more backing now we could
>> try it, otherwise we can just stick it into xfsqa which will hopefully
>> soon be generalized to a general fs QA suite.
> 
> Two questions --- first of all, has there been any progress with
> respect to fixing the licensing of the xfsqa tree.  (i.e., "All Rights
> Reserved" needs to change to a GPLv2 license)?  

Given that we are not lawyers:

The current kernel tree contains >3500 files that contain the phrase
"All Rights Reserved".  Are they a problem?


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
