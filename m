Return-Path: <linux-kernel-owner+w=401wt.eu-S1759580AbZFQASb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759580AbZFQASb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 20:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757024AbZFQASY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 20:18:24 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:39709 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756731AbZFQASX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 20:18:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=h5D+FavWLTQxmtJkaW5swLHT1Yx0wvnU31f203IHqesE7GeQDxdN84BCkESLGx8IQi
         AEBzIX5Dmn+svcWxH/8HwS1YD4gumHcEAzIGURgHSXKPY2fI9WvwrZZfoMY4JbVlguqm
         00Q9xjYjAlsdS9P5VOYJyw8lgFd54E6vnBkH0=
Message-ID: <4A38365F.1050409@gmail.com>
Date: Tue, 16 Jun 2009 18:18:39 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: David Lindsay <dav7@dav7.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: Kernel 2.4.0 ramdisk decompression infinite loop
References: <af7719af0906160127n36be4aa2qf5a309f44077b4b1@mail.gmail.com>
In-Reply-To: <af7719af0906160127n36be4aa2qf5a309f44077b4b1@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2009 02:27 AM, David Lindsay wrote:
> I know kernel 2.4.0 is old, but it's the oldest kernel my system will
> compile (with binutils 2.9.1 downloaded from kernel.org/lib/ and GCC
> 2.95.3), and I want a small kernel. ;-)
> If anyone knows how to make a (useful ;p) ~350kB 2.6, please do tell! :P

Surely at least the latest 2.4.x release is not that much larger. 2.4.0 
was surely riddled with bugs..
