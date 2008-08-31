Return-Path: <linux-kernel-owner+w=401wt.eu-S1758450AbYHaJfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450AbYHaJfX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 05:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754944AbYHaJfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 05:35:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:49959 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905AbYHaJfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 05:35:08 -0400
Message-ID: <48BA6580.8070206@kernel.org>
Date: Sun, 31 Aug 2008 11:33:52 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: xerces8 <xerces8@butn.net>
CC: Sergey Spiridonov <sena@hurd.homeunix.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: GA-MA790FX-DS5 SATA ahci NCQ erros on Jmicron 20360/20363		(JMB363)
 kernel 2.6.25-2 Debian/Lenny
References: <g8p6po$nm$1@ger.gmane.org> <48B0916C.4080805@garzik.org> <g8q9mg$v2p$1@ger.gmane.org> <WorldClient-F200808241844.AA44240046@butn.net> <48B92846.7050004@kernel.org> <WorldClient-F200808302013.AA13360018@butn.net>
In-Reply-To: <WorldClient-F200808302013.AA13360018@butn.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 31 Aug 2008 09:35:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xerces8 wrote:
> Tejun Heo wrote:
> 
>> xerces8 wrote:
>>> My WD MyBook Studio Edition 500 GB external eSATA drive does not
>>> work on the JMB363 correctly no matter what I try. Both
>>> under linux and windows. I think the best was 30 minutes of
>>> (apparent) error free operation under windows.
>> This one is being discussed both with JMB and WD.  It seems the bridge
>> chip used in the WD external drives is somehow incompatible with the
>> JMB ahci's.  Don't know whose fault it is or how it can be worked
>> around yet.  The issue is being tracked in the following bugzilla.
>>
>>   http://bugzilla.kernel.org/show_bug.cgi?id=9913
> 
> I know, I'm David Balažic (the last commenter on bug, besides you) ;-)

Somehow I've been confusing people a lot lately.  I asked my AMD contact
 a few times about sata_nv problems somehow thinking AMD acquired NVidia
instead of ATI.  :-)

-- 
tejun
