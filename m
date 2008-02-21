Return-Path: <linux-kernel-owner+w=401wt.eu-S1752037AbYBUCph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbYBUCph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 21:45:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbYBUCp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 21:45:28 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:10405 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761705AbYBUCp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 21:45:26 -0500
Message-ID: <47BCE5C3.7030006@xaerolimit.net>
Date: Wed, 20 Feb 2008 21:45:23 -0500
From: Chris Brennan <xaero@xaerolimit.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20080209)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: BT8x8 TV Card
References: <fa.8THcxUS0tA6NGzMwMdJ0gEixmMw@ifi.uio.no> <47BCBBCA.1080307@shaw.ca>
In-Reply-To: <47BCBBCA.1080307@shaw.ca>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are the updated pastbin links to my BT8x8 issue. Hopefully these
are helpful, if you need more information, let me know.


dmesg -> http://rafb.net/p/HfS8nS31.html
xorg.conf -> http://rafb.net/p/twDeb451.html
Xorg.0.log -> http://rafb.net/p/hBdXqc31.html
.config -> http://rafb.net/p/vs6MFW28.html

#################################################################################
# NOTICE: The contents of this e-mail and any attachments to it may   
     #
# contain privileged and confidential information from XaeroLimit   
     #
# Industries or its affiliates. This information is only for the
viewing     #
# or use of the intended recipient. If you are not the intended
recipient,     #
# you are hereby notified that any disclosure, copying, distribution
or use     #
# of, or the taking of any action in reliance upon, the information   
     #
# contained in this e-mail, or any of the attachments to this e-mail,
        #
# is strictly prohibited. If you have received this e-mail in error,
        #
# please immediately notify the sender by replying to this message and
        #
# delete it from your system.                             #
#################################################################################



Robert Hancock wrote:
> Chris Brennan wrote:
>> I'm having a kernel related issue (I think) with the BT878 card I
>> have in my gentoo box.
>>
>> Here are pastebin results of varius infomation, I hope I give all
>> the necessary info. If I am missing something or you need more,
>> please let me know.
>>
>> dmesg -> http://rafb.net/p/MVIiSg62.html xorg.conf ->
>> http://rafb.net/p/dXz4Ry49.html Xorg.0.log ->
>> http://rafb.net/p/LbPBZT56.html config ->
>> http://rafb.net/p/Dm5LDM88.html
>
> These links don't work.
>
>>
>> xawtv gives me a window and when I right click, I can choose what
>>  format and region and all that jazz, but I get no picture. I do
>> get a green overlay w/ some static when it doesn't cause my X
>> Session to freeze. Below is the console output of two apps I am
>> trying to use to access the TV Card.
>>
>> tvtime produces the following error:
>>
>> xaero@Leviathan ~ $ tvtime Running tvtime 1.0.2. Reading
>> configuration from /etc/tvtime/tvtime.xml Reading configuration
>> from /home/xaero/.tvtime/tvtime.xml xvoutput: No XVIDEO port
>> found which supports YUY2 images.
>>
>> *** tvtime requires hardware YUY2 overlay support from your video
>> card *** driver.  If you are using an older NVIDIA card (TNT2),
>> then *** this capability is only available with their binary
>> drivers. *** For some ATI cards, this feature may be found in the
>>  experimental *** GATOS drivers: http://gatos.souceforge.net/ ***
>> If unsure, please check with your distribution to see if your ***
>> X driver supports hardware overlay surfaces.
>>
>> xaero@Leviathan ~ $
>>
>> tvtime-scanner now that made my heart jump ... cause it scanned
>> and stored all my basic cable channels. But I still can't get a
>> video signal. So I am obviously missing something.
>>
>>
>> So hopefully someone can help me
>
> I assume you did read the message tvtime spit out and looked into
> it?
>

