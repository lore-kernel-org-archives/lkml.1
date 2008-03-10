Return-Path: <linux-kernel-owner+w=401wt.eu-S1757978AbYCJXPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978AbYCJXPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 19:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbYCJXP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 19:15:28 -0400
Received: from phoenix.slamd64.com ([217.10.145.2]:32990 "EHLO
	phoenix.slamd64.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757586AbYCJXPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 19:15:25 -0400
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: acer-wmi uses input:i8042_command() => build error
Date: Mon, 10 Mar 2008 23:14:26 +0000
User-Agent: KMail/1.9.7
Cc: Jiri Kosina <jkosina@suse.cz>, linux-acpi@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
References: <20080310124754.4ec3f24d.randy.dunlap@oracle.com> <Pine.LNX.4.64.0803102227540.18589@twin.jikos.cz> <20080310160649.5d225ac7.randy.dunlap@oracle.com>
In-Reply-To: <20080310160649.5d225ac7.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803102314.26951.carlos@strangeworlds.co.uk>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (phoenix.slamd64.com [217.10.145.2]); Mon, 10 Mar 2008 23:14:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 March 2008 23:06:49 Randy Dunlap wrote:
> Yes, thanks.
> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>

(I'll add this to my queue, although given my last set of patches hasn't been 
applied to the ACPI tree yet, and Len seems to have gone AWOL for the last 
two weeks since then, I have no idea on the chances of this getting in, 
unless someone else wants to pick it up?)

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
