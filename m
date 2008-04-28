Return-Path: <linux-kernel-owner+w=401wt.eu-S937580AbYD1Ut5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937580AbYD1Ut5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 16:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965391AbYD1Utf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 16:49:35 -0400
Received: from sd-green-bigip-66.dreamhost.com ([208.97.132.66]:55408 "EHLO
	spunkymail-a14.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965358AbYD1Ute (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 16:49:34 -0400
Message-ID: <481637D7.8090000@dawes.za.net>
Date: Mon, 28 Apr 2008 22:47:19 +0200
From: Rogan Dawes <lists@dawes.za.net>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
Cc: Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org
Subject: Re: Why these dot chars in scripts/checkpatch.pl?
References: <20080428153122.a94d21ba.pj@sgi.com>
In-Reply-To: <20080428153122.a94d21ba.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Andy,
> 
> Perhaps I'm loosing my magic regex pixie dust, but the dot '.' char
> in the pattern "/^.#" in the following lines looks wrong to me, as if
> one were trying to match pre-processor directives that were set in by
> one character:

Perhaps it is because checkpatch.pl is supposed to check *patches*, 
which are typically indented by one character (+- )?

Rogan

