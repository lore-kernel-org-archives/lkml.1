Return-Path: <linux-kernel-owner+w=401wt.eu-S1755815AbZCXVso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815AbZCXVso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 17:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750862AbZCXVse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 17:48:34 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:32813 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbZCXVsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:48:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=KndFswV0ONuxfNaPXZHgumawO2qZqDKzO8lhIePUZko1vagu0BAUiYnUHp5VbD9n9n
         tKH5cTZ+vQSZ1LnNk2mivm5D35OqAmntiz+yc/dxZWFG2ErwXJ3y4vORdr3qrEv3zCJH
         VOzoQEoXGJX3/lJeP27KW9Q5q4Ww4tZup44L0=
Message-ID: <49C9552B.1090701@gmail.com>
Date: Tue, 24 Mar 2009 22:48:27 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-8.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: one more tty reference leak [Was: 2.6.30 -mm merge plans]
References: <20090323224615.cd29edfd.akpm@linux-foundation.org>
In-Reply-To: <20090323224615.cd29edfd.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.3.2009 06:46, Andrew Morton wrote:
>      isicom-isicom-kref-leak-fix.patch
>      isicom-isicom-kref-leak-fix-fix.patch
...
>   Merge, backport to 2.6.29.x

Could you (or Alan) also pick
http://lkml.org/lkml/2009/3/16/159
up and merge?
