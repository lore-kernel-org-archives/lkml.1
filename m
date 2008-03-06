Return-Path: <linux-kernel-owner+w=401wt.eu-S932828AbYCFLUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932828AbYCFLUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 06:20:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761160AbYCFLUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 06:20:43 -0500
Received: from gv-out-0910.google.com ([216.239.58.185]:57083 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756971AbYCFLUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 06:20:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=OHMVj9+w+c0PMEXYjFgimRnCSBYKc1PfSQPcLQcZZe53RcL0OYnxqZ4MK01y3XNXAUcrXFMeV5MXjKhbxbwuH0R+dI00wk8zx2c7fc1SdgcYzgpa4uvPoTk08QwUi2hTHUOVV8f817vd2y4sIFe6HiSTI8+GQJQhHZ0P+aUNWHQ=
Message-ID: <e9e943910803060320o1992b488h799218cafc5a02be@mail.gmail.com>
Date: Thu, 6 Mar 2008 11:20:39 +0000
From: "Duane Griffin" <duaneg@dghda.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [RFC, PATCH 0/6] ext3: do not modify data on-disk when mounting read-only filesystem
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Theodore Tso" <tytso@mit.edu>, sct@redhat.com, adilger@clusterfs.com
In-Reply-To: <20080305194220.f9cce55e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1204768754-29655-1-git-send-email-duaneg@dghda.com>
	 <20080305194220.f9cce55e.akpm@linux-foundation.org>
X-Google-Sender-Auth: a05b6c3a03ca0386
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2008, Andrew Morton <akpm@linux-foundation.org> wrote:
> I'll grab the first three for now, thanks.

Great, thanks!

> Someone(tm) should do the jbd2 versions..

I'll do them tonight, unless someone beats me to it.

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
