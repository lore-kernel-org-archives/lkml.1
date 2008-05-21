Return-Path: <linux-kernel-owner+w=401wt.eu-S1765455AbYEUJLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765455AbYEUJLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 05:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbYEUJLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 05:11:12 -0400
Received: from pilet.ens-lyon.fr ([140.77.167.16]:59824 "EHLO
	pilet.ens-lyon.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbYEUJLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 05:11:11 -0400
Date: Wed, 21 May 2008 11:11:11 +0200
From: Benoit Boissinot <bboissin@gmail.com>
To: Soumyadip Das Mahapatra <kernelhacker@visualserver.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] bitreversal program
Message-ID: <20080521091111.GU7567@pirzuine>
References: <Pine.LNX.4.64.0805191859411.18461@visualserver.org> <1211229736.5915.86.camel@brick> <Pine.LNX.4.64.0805201254240.18899@visualserver.org> <961aa3350805200513i4e02716eh79da76345718c3b2@mail.gmail.com> <Pine.LNX.4.64.0805201716160.25111@visualserver.org> <40f323d00805200847t77b2d875j451d0eb9758cf9ff@mail.gmail.com> <Pine.LNX.4.64.0805201753430.25485@visualserver.org> <20080520163912.GP7567@pirzuine> <Pine.LNX.4.64.0805211029250.1736@visualserver.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805211029250.1736@visualserver.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 21, 2008 at 10:54:15AM +0200, Soumyadip Das Mahapatra wrote:
> On Tue, 20 May 2008, Benoit Boissinot wrote:
>
> Sorry to disturb you again. But i tested my code against Akinobu's one
> and the test result shows my code takes less cpu time than that of
> Akinobu's.
>
> My processor is 1.4 GHz one.
> I am not forcing you to review my code( or i've no expectation of
> inclusion of it ) but its just a curiousity: what is truth behind
> the output.

I'm using a core duo 1.2GHz, if you want to play with the code, I'm
attaching a tarball (it's hackish, just change the #include at the top
of bitrev.h to switch implementation).

I'm using gcc -Wall -O3 to compile with gcc 4.2.3.

regards,

Benoit

-- 
:wq

--Q68bSM7Ycu6FN28Q
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="bitrev.tar.bz2"
Content-Transfer-Encoding: base64

QlpoOTFBWSZTWZjwXKkABa9/hty4AIBZf///Umd/av/v3/4AAQCAAAhgBp88qvEvB7vT3buv
XeGq2qgDEopsqfqng1Gp79SfqpPeVJkHqZPaoAGgGTRtQAyBUSeoBo//1VSH+qgPU0AA0AAG
gAAAANEE9RPQPU1JiaNAAAAAAAAAAJEiJpqZpT9qKfqEMmGo0AyABoADRo0aeoHMJoDQGjRh
GgxGmJkxNBhGgZAMmAiUSPUCU/aHqmRqn5U8o9NQAAGg0A0A0Aep8qeB9h5J1dYeh0WSxQiE
zKoczt7Cpb6zJnz6sKiWDL2WqYYV7fR3ZE0iTglASJQg2tq1ZA79dwsIABsaYNOg3tc+6kli
gGamu8tuQxqWJthUMLLAPf739OtJn4q/U87Vyxlt0HEwjXUIMDbDJjpSo7bJ1JAHzJBQzqG1
P6JJI2220fYDlPEtSshEIxIV6a3emsgV90LkgiUIIEIiJCCBCAhCCyR+IhKuHnBkEpDkSJFU
yc3M5c4i9F6JblEP6zrSM8AJBSGMYyRg+MIOxvfALc2feS28mb4dOnscKMlv3KKjByuRtoxf
qaTeOmCiXIB0gPEStTzlFMcCuWhH2hIYaPh3E4MJ8GANCGEtm8w9QyhXNBlPM10ljoyVm+5d
13cMRGjFUeBHWN8a0i/qfAwiQhZcfRkBkeYDJJaqyoBubcceavoVVTnPDeNc008zTuCCG++u
PLljezknYhWELpGADIwUdCqa5NzY31Vcu7uHvWcCIiIiJCEIUUU3pAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAFi5XlMV5V58+fQlPPKpYooplNTUd8CkBgIuBGNgDlCVu5uO7vXniLs
cZKiDk0MQdz6nJ8+auoLmkYhFhO5zRdWisRkqmy5oxYQjGSEgSz8eBFYQAiqLSBhw4cOHDhw
z49GvXr3686X2IjOi2G2VTgrnikiNVjeympOW5tk6xDKhii0FIYMwwwwwwwwtphkww0dG+oZ
Yy9/sfu1oJHhAGgoTNgYjGMYxjGyuiE8aVrQGrrufeBBgD3HdTcMJpWpMLEqGO3QwAWMjabC
A7u72O72PhxPmfav2GWOysIhyWOCBlBieMtdKUpSlKZct+bLl6FEjYlaSkI0ylMjAJYTHHHH
HHHHHPqx1a8cccspJDB3wDDXMe9glJoMMBOVVVVVVhSq1U12MUGchlmE22rMMxSraDvWnUkb
3ve973vsvs2bN19wm7b1YkqJTRERERERERERWlK4nlNbzym1dS+tJFrpXVSXNv1a1VorWszT
Cl8+rP0V18/GcYBEX3DxiUF/sfM+qNEJdjkFpmg+/aUlzC5VMVS/MhfqutcwGhbA7Uc/Oc6C
SWUgUlYvVr19Q2b28zN3zlIvBGsYSGr4L6+Gq/g1Yr+7fbxcQIsCQRzFAbOV+S4cO7RoFGyw
gKIiIi2IiIiIiATmSSOfj2IIf1f7lwcaICRO2UwPtLAdK9iI6YDe71gVylglKWOUpSlKUpSB
GZDIEgiG1E6Gbb3MCklC9bXve973ve973uL9KzEdz/rfCr4nLuIYFBGg5e0BUj3KsGABF+q9
ju+J3d3d3zgi0ajAo9LeSngM2oSOXX5eLMLfxofYEhNLpCxyEEaRI8mk6QewUfkQwA3RSKVO
2c5565znOc51CeQsQwYjaENElKBjhcMFFnWnYRJ2EyAcPDvEw4dgHKvfCocX/PKSSHie19Kw
c4YLd7wwyauHEGjfyxwNtxmKrd2Aa4taEkSYqAQLtu7gqUtkMOPBaJh0nEgTjQpI5YuzKb3B
wA30sJUyMIrZAiieNGOJCHaWivRX+DN29HII26zMK5GMmyg06jnDny3Kkc4a4GYnSmdmNBL5
ikhN8aOEDK470tG0z0M6cg+4zV4aMu+UmgNbIciUKrKNVOgE3sNC5N4ddKvan/JUV0jiPw/A
27Y4ShCEYQ8+c0OTecR8E69SjYglq3pgOgHwSFH00ETuKUERzBzmkTf3Cm+xtSCRaKH/i7ki
nChITHguVIA=

--Q68bSM7Ycu6FN28Q--
