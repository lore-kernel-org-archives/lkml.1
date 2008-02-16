Return-Path: <linux-kernel-owner+w=401wt.eu-S1756666AbYBPNic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbYBPNic (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 08:38:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbYBPNiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 08:38:23 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:60617 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078AbYBPNiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 08:38:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=f2Z+Vlw1m8Nj1kMaAFmXTvX+7U4LZAYGMBmoru3ITFBSgXUxU/cqBQvuiP+Q81liqJIvYMXTO0lR4nW2/lwxUes26hWPp4eocOoYhRXG3W//wlQ+f+iJUj3QzDNXb5nY/FgahB1ilfWfiW8yx/jStmTaX6F7wscslc4hFwOSMA0=
Message-ID: <2f11576a0802160538w3ad026ediebfad03b53885b3@mail.gmail.com>
Date: Sat, 16 Feb 2008 22:38:20 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [RFC] bitmap onto and fold operators for mempolicy extensions
Cc: "David Rientjes" <rientjes@google.com>, Lee.Schermerhorn@hp.com,
       mel@csn.ul.ie, ak@suse.de, linux-kernel@vger.kernel.org,
       ray-lk@madrabbit.org, akpm@linux-foundation.org, clameter@sgi.com
In-Reply-To: <20080216123315.28685.5796.sendpatchset@jackhammer.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080216123315.28685.5796.sendpatchset@jackhammer.engr.sgi.com>
X-Google-Sender-Auth: 3b6dbd2522f253b6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

> The bitmap_fold() operator folds a bitmap into a second that
> has bit m set iff the input bitmap has some bit n set, where
> m == n mod sz, for the specified sz value.

iff?
other portions looks good :)

Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Thanks!
