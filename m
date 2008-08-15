Return-Path: <linux-kernel-owner+w=401wt.eu-S1755036AbYHOLdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbYHOLdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 07:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752877AbYHOLdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 07:33:08 -0400
Received: from eagle.jhcloos.com ([207.210.242.212]:2709 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbYHOLdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 07:33:07 -0400
From: James Cloos <cloos@jhcloos.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Would it be better for git-commits-head to have -M -C diffs?
In-Reply-To: <1218751750.3184.18.camel@pmac.infradead.org> (David Woodhouse's
	message of "Thu, 14 Aug 2008 23:09:10 +0100")
References: <m3ljyzsfg6.fsf@lugabout.jhcloos.org>
	<1218751750.3184.18.camel@pmac.infradead.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.60 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAI1J
 REFUOE+lU9ESgCAIg64P1y+ngUdxhl5H8wFbbM0OmUiEhKkCYaZThXCo6KE5sCbA1DDX3genvO4d
 eBQgEMaM5qy6uWk4SfBYfdu9jvBN9nSVDOKRtwb+I3epboOsOX5pZbJNsBJFvmQQ05YMfieIBnYX
 FK2N6dOawd97r/e8RjkTLzmMsiVgrAoEugtviCM3v2WzjgAAAABJRU5ErkJggg==
Copyright: Copyright 2008 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
Date: Fri, 15 Aug 2008 07:31:55 -0400
Message-ID: <m3wsiiqzst.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Hashcash: 1:23:080815:dwmw2@infradead.org::RN2tme4RfDGq9B03:0000000000000000000000000000000000000000000EOm
X-Hashcash: 1:23:080815:linux-kernel@vger.kernel.org::VwoRPGEE9PO2b9im:000000000000000000000000000000000KhTr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "David" == David Woodhouse <dwmw2@infradead.org> writes:

JimC> I think it would also be useful were the From: header of each
JimC> message set to the commit's Author.  I run each commit through a
JimC> script to do that locally, but the archives would also benefit
JimC> from that.

David> It would be nice, but I'm not sure it's a good idea. They aren't
David> always valid email addresses. Maybe a Reply-To: header, rather
David> than From: ?

I'd still need to pass them through the script I use; the point is to
have the summary window in my MUA display useful names in the mail
author column.  

Archive searching would also need it to be the From: header.

They would, though, probably need a Reply-To:, MFT: or similar pointing
replies to linux-kernel.  I hadn't thought of that aspect until reading
your reply....

I suppose the -M -C change would be enough for now.

-JimC (still waking up)
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
