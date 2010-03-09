Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582Ab0CIPAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 10:00:20 -0500
Received: from mail-fx0-f227.google.com ([209.85.220.227]:56793 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab0CIPAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 10:00:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=ofZ5g3pj0zNqnmu6HJewNCKxNsIl0n4RPYSkOPxPC3WRJfEQ6K63XM5BvDTJil2gW6
         vlLkv8sBRKtBDDPAll/5eBPuzdashoj55pIaFKavdsh6kA2bvJFmDZJZfkvfAp79mTka
         3rh4vvqVjBSauHBt7T3YtYr277nw5BomlpEFk=
MIME-Version: 1.0
In-Reply-To: <1268126817.10479.643.camel@localhost>
References: <1268126817.10479.643.camel@localhost>
From: Ulrich Drepper <drepper@gmail.com>
Date: Tue, 9 Mar 2010 06:59:55 -0800
Message-ID: <a36005b51003090659m641b1297g32f3327b83917452@mail.gmail.com>
Subject: Re: opendir() on a file???
To: Jon Masters <jonathan@jonmasters.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 9, 2010 at 01:26, Jon Masters <jonathan@jonmasters.org> wrote:
> Now I might be missing something, and I know I'm behind on LKML[0], but
> the following isn't supposed to work in my book:

Al introduced and fixed the problem, from what I've seen.
