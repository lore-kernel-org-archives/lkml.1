Return-Path: <linux-kernel-owner+w=401wt.eu-S1755170AbYJFTqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbYJFTqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 15:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755628AbYJFTqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 15:46:14 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:7029 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564AbYJFTqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 15:46:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ec3EXrceCCcTePwJ0OWkUP/25nZHLAXaSwRtitEFHqHVjxbd1c+eNpVrVZGwTTJMML
         lh3PWh1U3qbkbMrD5Nmp77qvNgTAHylE5KkRhmKR6vHOk4pdY6FN27iaZghqc5m4c7c+
         mPQ9Dsrg4KAbgpGtCoEzG7NqSTNIINVSGK928=
Message-ID: <9e4733910810061246t3d0f4671se3cef6813a96e84e@mail.gmail.com>
Date: Mon, 6 Oct 2008 15:46:11 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: linux-kernel@vger.kernel.org, lirc-list@lists.sourceforge.net
Subject: Re: [RFC PATCH 0/4] V3 - Implementation of IR support using the input subsystem
In-Reply-To: <20081006194032.15992.8393.stgit@terra>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081006194032.15992.8393.stgit@terra>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 6, 2008 at 3:43 PM, Jon Smirl <jonsmirl@gmail.com> wrote:
> Third pass at implementing evdev support for IR. The goal of in-kernel IR is to integrate IR events into the evdev input event queue and maintain ordering of events from all input devices.


Mail to LIRC list still bounces because it is slightly too big - over
the 20K limit.

Messages are here:
http://lkml.org/lkml/2008/10/6/202


-- 
Jon Smirl
jonsmirl@gmail.com
