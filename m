Return-Path: <linux-kernel-owner+w=401wt.eu-S1762223AbZBYXe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762223AbZBYXe3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 18:34:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755443AbZBYXeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 18:34:21 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:33419 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409AbZBYXeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 18:34:20 -0500
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Feb 2009 18:34:20 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=WwaZydmAwHTK/dP9EYaLIRHXkt/SvHT99KIYZiTHJ+Kz0k2AnZgENzj5uIOTehXJ8H
         0JG3mcnppI0FQnRUywQriiDqC55cFcQL32anI9dFVrAaN4nzmThg8TBvQ4RiMEqzary4
         pnVtC7pZeN6XurhLW3fl9+JXFLuexA6tBlk2k=
Message-ID: <49A5D3F7.9070408@gmail.com>
Date: Thu, 26 Feb 2009 00:27:51 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090218 SUSE/3.0b2-1.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: sidc7 <siddhartha.chhabra@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: page_address not working
References: <22193693.post@talk.nabble.com>
In-Reply-To: <22193693.post@talk.nabble.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.2.2009 01:12, sidc7 wrote:
> "Implict declaration of page_address".

Do you have
#include <linux/mm.h>
in there?
