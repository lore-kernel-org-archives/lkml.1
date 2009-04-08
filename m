Return-Path: <linux-kernel-owner+w=401wt.eu-S1764427AbZDHScs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764427AbZDHScs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 14:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655AbZDHSch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 14:32:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40412 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbZDHScg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 14:32:36 -0400
Message-ID: <49DCED9A.8030108@zytor.com>
Date: Wed, 08 Apr 2009 11:31:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [PATCH] disable interrupt shadow state for emulated instruction
References: <1239213452-5966-1-git-send-email-glommer@redhat.com> <49DCE9E5.8020703@zytor.com> <20090408183110.GD25323@poweredge.glommer>
In-Reply-To: <20090408183110.GD25323@poweredge.glommer>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa wrote:
> mov ss is a non-issue, since it is executed natively.

In real mode?

	-hpa
