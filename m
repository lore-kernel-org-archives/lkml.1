Return-Path: <linux-kernel-owner+w=401wt.eu-S1757178AbYKUUWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178AbYKUUWh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 15:22:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753757AbYKUUW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 15:22:28 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:35343 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbYKUUW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 15:22:27 -0500
Message-ID: <154e089b0811211222x5340b78cx496edb25abd1147f@mail.gmail.com>
Date: Fri, 21 Nov 2008 21:22:25 +0100
From: "Hannes Eder" <hannes@hanneseder.net>
To: "David Howells" <dhowells@redhat.com>
Subject: Re: [PATCH] CRED: fix compilation warning in function 'get_cred'
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <18016.1227284707@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <154e089b0811201400w6b5d249eyc21ebb9a76133d08@mail.gmail.com>
	 <11321.1227219571@redhat.com>
	 <154e089b0811210654v45126cbene22d925a1760d9e2@mail.gmail.com>
	 <18016.1227284707@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 5:25 PM, David Howells <dhowells@redhat.com> wrote:
> Hannes Eder <hannes@hanneseder.net> wrote:
>
>> What do you suggest, report this as a gcc bug?
>
> You could do.  It might be worth checking to see if it's fixed with a newer
> gcc first, though.

The spurious warning is gone with gcc (Ubuntu 4.3.2-1ubuntu11) 4.3.2.

Hannes
