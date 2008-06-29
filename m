Return-Path: <linux-kernel-owner+w=401wt.eu-S1754266AbYF2Vuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbYF2Vuv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 17:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbYF2Vul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 17:50:41 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:3463 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbYF2Vuk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 17:50:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=raGcbIo9Abkx4rq6T6N+cHFUFS2G+A0WNN1FUg8izhwxTWKtZMpFjFLeEz+k9fePw2
         zHbjmTfgJ74HoEGuX+168mYhl9VYUNRotMlOrQZqSit+x6jAVYSpFHD3VgeP1ynUvzy3
         pEJK3qhJB7YgCVPh+DucnjYI4rZIyRMse2Uj8=
Message-ID: <dd18b0c30806291450i6e820934j8e7c2446327c2bde@mail.gmail.com>
Date: Sun, 29 Jun 2008 21:50:37 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "=?ISO-8859-1?Q?Ville_Syrj=E4l=E4?=" <syrjala@sci.fi>,
       "Justin Mattock" <justinmattock@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [Bug #10954] hda_intel: azx_get_response timeout, switching to polling mode: last cmd=0x011f000c
In-Reply-To: <20080629210743.GL19430@sci.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <q5WW6DLC10O.A.dxC.R69ZIB@albercik>
	 <X8mbwW6K81I.A.9LE.N79ZIB@albercik>
	 <dd18b0c30806291328o55d1be25t4d692344bbc3d129@mail.gmail.com>
	 <20080629210743.GL19430@sci.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29, 2008 at 9:07 PM, Ville Syrjälä <syrjala@sci.fi> wrote:
> On Sun, Jun 29, 2008 at 08:28:58PM +0000, Justin Mattock wrote:
>> On Sun, Jun 29, 2008 at 6:18 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > This message has been generated automatically as a part of a report
>> > of recent regressions.
>> >
>> > The following bug entry is on the current list of known regressions
>> > from 2.6.25.  Please verify if it still should be listed.
>> >
>> >
>> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10954
>> > Subject         : hda_intel: azx_get_response timeout, switching to polling mode: last cmd=0x011f000c
>> > Submitter       : Justin Mattock <justinmattock@gmail.com>
>> > Date            : 2008-06-21 2:05 (9 days old)
>> > References      : http://marc.info/?l=linux-kernel&m=121401399622190&w=4
>> >
>> >
>> >
>>
>> yes; still seeing this pop up,(problem is I can't reproduce this)
>
> This happened to me a few times a while back. It happened when watching
> videos with mplayer. It only occured sometimes when switching from one
> video file to the next. I haven't seen it in a while though.
>
> Right now I have the HDA power save timeout set to 2 seconds. It is
> possible I had it set to 1 second when I saw the problem, however I
> can't be absolutely certain about that.
>
> --
> Ville Syrjälä
> syrjala@sci.fi
> http://www.sci.fi/~syrjala/
>

Hello; thanks for the info. I'll have a look into that and see if I
can reproduce this.
regards;

-- 
Justin P. Mattock
