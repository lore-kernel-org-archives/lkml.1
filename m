Return-Path: <linux-kernel-owner+w=401wt.eu-S966206AbYCSWA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966206AbYCSWA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755169AbYCSUX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:23:27 -0400
Received: from rn-out-0910.google.com ([64.233.170.190]:23930 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932782AbYCSUXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:23:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NSp3Zrj+h7DD/K3hbx9c+roy+DGRxLCSr6LAM4Qraa5m/32PCEzuY/ev3B0VHFxigzZxu6QTYBHvo7uhTwPTJZN2+Wfb7n0SHWWss5F4r5U9zgU7r6SrH6eHXb/5ntppBkgJRwtcC/bkXu/t/MDpjtn33Pc1FSpbWUg+U9SJC8s=
Message-ID: <170fa0d20803191323o65bd9738j80511de2c9f6a03c@mail.gmail.com>
Date: Wed, 19 Mar 2008 16:23:23 -0400
From: "Mike Snitzer" <snitzer@gmail.com>
To: "Daniel Phillips" <phillips@phunq.net>
Subject: Re: [ANNOUNCE] ddtree: A git kernel tree for storage servers
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200803190102.25491.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803190102.25491.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/19/08, Daniel Phillips <phillips@phunq.net> wrote:
> Hi all,
>
>  I have set up a new git tree to better serve the needs of those
>  interested in advanced storage applications and development.

Thanks for formalizing a repo for all the interesting work you do.

>  This ddtree git repository aims to provide a congenial forum for
>  development of forward looking storage features such as replication and
>  clustering; and to provide improved kernels for those who consider it
>  important that their storage servers run efficiently under heavy load
>  without deadlocking.
>
>  What will be in this ddtree?
>
>   * Block layer deadlock fixes (Status: production)

Do you happen to have a pointer to where these block layer deadlock
fixes are?  Or will you be committing them shortly?

regards,
Mike
