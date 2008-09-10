Return-Path: <linux-kernel-owner+w=401wt.eu-S1755468AbYIJV0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468AbYIJV0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 17:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbYIJV0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 17:26:15 -0400
Received: from qb-out-0506.google.com ([72.14.204.235]:32062 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbYIJV0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 17:26:14 -0400
Message-ID: <f488382f0809101426g158a6043l1db8f4e26fdc9c06@mail.gmail.com>
Date: Wed, 10 Sep 2008 14:26:12 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: linux-kernel@vger.kernel.org
Subject: Re: Semi-repeatable hard lockup on 2.6.27-rc6
In-Reply-To: <f488382f0809101107h4ce8b912o1093adb44c157005@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f488382f0809101107h4ce8b912o1093adb44c157005@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 11:07 AM, Steven Noonan <steven@uplinklabs.net> wrote:
> I've got a hard lockup problem on boot of 2.6.27-rc6. It's sporadic
> though. Sometimes it locks, sometimes not. Each time it -does- lock
> up, it gets to 'Waiting for uevents to be processed' and then
> immediately locks up.
>

This problem does -not- occur on 2.6.27-rc6-tip, though. Something's
screwy in the pristine 2.6.27-rc6 branch.

- Steven
