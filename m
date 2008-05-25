Return-Path: <linux-kernel-owner+w=401wt.eu-S1755426AbYEYNOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426AbYEYNOV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 09:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbYEYNOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 09:14:12 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:61967 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbYEYNOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 09:14:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rzDdwF2dYSpNyQK3FOTWOOfuUEzSwtZyLbLUTC8FDN6QTwqKkfR4eFUogGSP+Qa3R4pSjQ1LnRKeOPftGxDrWzB1bKa/866JAMEPjO6NrNcd5ydcJdpgEJ+RTxkdn3AlPPkPS06nX3nUxQEPew8C56YsXIqAXWziZazDKUG2OEs=
Message-ID: <7b9198260805250614k1a79b0d4p4322c89219be438a@mail.gmail.com>
Date: Sun, 25 May 2008 14:14:08 +0100
From: "Tom Spink" <tspink@gmail.com>
To: "David Newall" <davidn@davidnewall.com>
Subject: Re: Inserting code from userspace to kernel space
Cc: devzero@web.de, "Shuduo Sang" <sangshuduo@gmail.com>,
       bosko.radivojevic@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <483959DD.8020505@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <290982711@web.de> <483959DD.8020505@davidnewall.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

2008/5/25 David Newall <davidn@davidnewall.com>:
> devzero@web.de wrote:
>> this can be illegal, too.
>>
>> http://www.gnu.org/licenses/gpl-faq.html#ModifiedJustBinary
>>
>
> I think what he's trying to achieve is an unmodified or modified but
> fully GPL kernel plus a separate, proprietary binary to be loaded at
> runtime.

I think so to, but I think Shuduo misunderstood what question DevZero
was asking.  DevZero was asking for the source-code to the
infrastructure Shuduo used to implement this mechanism, i.e. the
loader and parser/interpreter that lives in the kernel - not the
application code.

-- 
Tom Spink
