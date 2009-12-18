Return-Path: <linux-kernel-owner+w=401wt.eu-S1751069AbZLRFLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751069AbZLRFLN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 00:11:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750797AbZLRFLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 00:11:12 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:26815 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbZLRFLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 00:11:11 -0500
Date: Thu, 17 Dec 2009 21:10:40 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Sunil Mushran <sunil.mushran@oracle.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] Add FIEMAP_EXTENT_SHARED flag
Message-ID: <20091218051040.GB20149@mail.oracle.com>
Mail-Followup-To: Sunil Mushran <sunil.mushran@oracle.com>,
	akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
References: <1259873212-20107-1-git-send-email-sunil.mushran@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259873212-20107-1-git-send-email-sunil.mushran@oracle.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090201.4B2B0EE5.0167:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 03, 2009 at 12:46:50PM -0800, Sunil Mushran wrote:
> Please could you Ack this patch. This adds a new FIEMAP flag to denote
> shared extents which we are using to identify such exents in reflinked
> files.

	These patches are now in ocfs2.git.  If anyone has any concerns,
let me know.

Joel

-- 

Life's Little Instruction Book #464

	"Don't miss the magic of the moment by focusing on what's
	 to come."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
